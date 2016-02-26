require 'nokogiri'

module Lita
  module Handlers
    class Wtf < Handler
      config :see_also, required: false, type: Array, default: []
      config :api_keys, required: false, type: Hash, default: {}

      SOURCE_NAMES = {
        'merriam' => 'Merriam-Webster Collegiate Dictionary',
        'urbandictionary' => 'UrbanDictionary'
      }

      route(
        /^wtf(?:\s+is)?\s(?<term>[^\s@#]+)(?:\?)?/,
        :lookup,
        command: true,
        help: {
          t('help.wtf.syntax') => t('help.wtf.desc')
        }
      )

      route(
        /^define\s(?<term>[^\s@#]+)\sis\s(?<definition>[^#@]+)$/,
        :define,
        command: true,
        help: {
          t('help.define.syntax') => t('help.define.desc')
        }
      )

      def lookup(response)
        term = response.match_data['term']
        if known?(term)
          response.reply(format_definition(term, definition(term)))
        else
          config.see_also.each do |source_name|
            definition = self.send("lookup_#{source_name}", term)
            if definition
              return response.reply(t('wtf.seealso',
                term: term, definition: definition, source: SOURCE_NAMES[source_name]))
            end
          end
          response.reply(t('wtf.unknown', term: term))
        end
      end

      def define(response)
        term = response.match_data['term']
        info = response.match_data['definition']
        write(term, info, response.user.id)
        response.reply(format_definition(term, definition(term)))
      end

      private

      def format_definition(term, definition)
        t('wtf.is', term: term, definition: definition)
      end

      def known?(term)
        redis.exists(term.downcase)
      end

      def definition(term)
        redis.hget(term.downcase, 'definition')
      end

      def write(term, definition, owner)
        redis.hset(term.downcase, 'definition', definition)
        redis.hset(term.downcase, 'owner', owner)
      end

      def lookup_merriam(term)
        api_key = config.api_keys['merriam']
        response = http.get("http://www.dictionaryapi.com/api/v1/references/collegiate/xml/#{term}", key: api_key)
        if response.status == 200
          doc = Nokogiri::XML(response.body) do |config|
            config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NONET
          end

          entries = doc.css("//entry/@id")
          unless entries.empty?
            first_entry_key = entries[0].value
            defs = doc.css("//entry[@id=\"#{first_entry_key}\"]/def/dt")
            defs.inject('') { |str, definition| str << "\n - " << definition.text[1..-1] }
          end
        end
      end

      def lookup_urbandictionary(term)
        response = http.get("http://api.urbandictionary.com/v0/define", term: term)
        if response.status == 200
          def_list = JSON.parse(response.body)['list']

          if def_list && def_list.size > 0
            def_text = def_list[0]['definition']
            def_text = def_text[0].downcase + def_text[1..-1] # uncapitalize the first letter
            def_text.gsub("\r\n\r\n", "\r\n") # remove empty lines
          end
        end
      end
    end

    Lita.register_handler(Wtf)
  end
end
