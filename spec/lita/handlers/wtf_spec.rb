require 'spec_helper'

describe Lita::Handlers::Wtf, lita_handler: true do
  it { is_expected.to route_command('wtf is foo').to(:lookup) }
  it { is_expected.to route_command('wtf foo').to(:lookup) }
  it { is_expected.to route_command('define foo is bar').to(:define) }

  describe '#lookup' do
    before do
      robot.config.handlers.wtf.see_also = []
      send_command('define web is Rails. Rails. Rails.')
    end

    it 'responds with the definition of the service' do
      send_command('wtf is web')
      expect(replies.last).to eq('web is Rails. Rails. Rails.')
    end

    it 'responds with the definition of a capitalized service' do
      send_command('wtf is WEB')
      expect(replies.last).to eq('WEB is Rails. Rails. Rails.')
    end

    it 'responds with an error if there is no such service' do
      send_command('wtf is foo')
      expect(replies.last).to eq('I don\'t know what foo is, ' \
                                 'type: define foo is <description> to set it.')
    end
  end

  describe 'with urbandictionary enabled' do
    before do
      # NOTE: It'd be nice to stub out the response from UD, since we don't
      #       want to hit their API every time we run a test.
      robot.config.handlers.wtf.see_also = ['urbandictionary']
    end

    it 'responds with see also text' do
      send_command('wtf is foo')
      expect(replies).to include('According to UrbanDictionary, foo is an term used ' \
                                 'for unimportant variables in programming when the ' \
                                 'programmer is too lazy to think of an actual name.  ' \
                                 'The origin of such word is described in detail in ' \
                                 "[RFC] 3092.\nTo replace this with our own " \
                                 'definition, type: define foo is <description>.')
    end
  end
end
