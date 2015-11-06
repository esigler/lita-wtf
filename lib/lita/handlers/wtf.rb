module Lita
  module Handlers
    class Wtf < Handler
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
        return response.reply(t('wtf.unknown', term: term)) unless known?(term)
        response.reply(format_definition(term, definition(term)))
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
    end

    Lita.register_handler(Wtf)
  end
end
