module Lita
  module Handlers
    class Wtf < Handler
      config :see_also, required: false, type: Array, default: []
      config :api_keys, required: false, type: Hash, default: {}

      SOURCE_NAMES = {
        'merriam' => 'Merriam-Webster Collegiate Dictionary',
        'urbandictionary' => 'UrbanDictionary'
      }.freeze

      route(
        /^wtf(?:\s+is)?\s+(?<term>[^\s@#]+)(?:\?)?/,
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
        return response.reply(format_definition(term, definition(term))) if known?(term)

        definition, source_name = alternate_definition(term)

        if definition
          return response.reply(t('wtf.seealso',
                                  term: term,
                                  definition: definition,
                                  source: SOURCE_NAMES[source_name]))
        end

        response.reply(t('wtf.unknown', term: term))
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

      def alternate_definition(term)
        config.see_also.each do |source_name|
          definition = send("lookup_#{source_name}", term)
          return definition, source_name if definition
        end

        nil
      end

      def lookup_merriam(term)
        api_key = config.api_keys['merriam']
        # FIXME: Add timeouts.
        response = http.get('http://www.dictionaryapi.com/api/v1/'\
                            "references/collegiate/xml/#{term}",
                            key: api_key)

        raise unless response.status == 200

        format_merriam_entries(response.body)
      rescue StandardError
        nil
      end

      def format_merriam_entries(content)
        nokogiri_dom = Nokogiri::XML(content) do |config|
          config.options = Nokogiri::XML::ParseOptions::STRICT |
                           Nokogiri::XML::ParseOptions::NONET
        end

        nokogiri_dom.css('//entry[1]/def/dt/text()').to_s[1..-1]
      rescue StandardError
        nil
      end

      def lookup_urbandictionary(term)
        # FIXME: Add timeouts.
        response = http.get('http://api.urbandictionary.com/v0/define',
                            term: term)

        def_list = JSON.parse(response.body)['list']
        def_text = def_list[0]['definition'].strip
        def_text[0] = def_text[0].chr.downcase
        def_text
      rescue StandardError
        nil
      end
    end

    Lita.register_handler(Wtf)
  end
end
