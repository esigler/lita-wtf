require 'spec_helper'

describe Lita::Handlers::Wtf, lita_handler: true do
  it do
    is_expected.to route_command('wtf is foo').to(:lookup)
    is_expected.to route_command('wtf foo').to(:lookup)
    is_expected.to route_command('define foo is bar').to(:define)
  end

  describe '#lookup' do
    it 'responds with the definition of the service' do
      send_command('define web is Rails. Rails. Rails.')
      send_command('wtf is web')
      expect(replies.last).to eq('web is Rails. Rails. Rails.')
    end

    it 'allows definitions with lots of weird characters' do
      send_command('define &&--88^%!$*() is garbage text')
      send_command('wtf is &&--88^%!$*()')
      expect(replies.last).to eq('&&--88^%!$*() is garbage text')
    end

    it 'responds with the definition of a capitalized service' do
      send_command('define web is Rails. Rails. Rails.')
      send_command('wtf is WEB')
      expect(replies.last).to eq('WEB is Rails. Rails. Rails.')
    end

    it 'responds with an error if there is no such service' do
      send_command('wtf is foo')
      expect(replies.last).to eq('I don\'t know what foo is, ' \
                                 'type: define foo is <description> to set it.')
    end
  end
end
