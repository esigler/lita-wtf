require 'spec_helper'

describe Lita::Handlers::Wtf, lita_handler: true do
  it { is_expected.to route_command('wtf is foo').to(:lookup) }

  it { is_expected.to route_command('wtf foo').to(:lookup) }
  it { is_expected.to route_command('wtf foo ').to(:lookup) }
  it { is_expected.to route_command('wtf  foo').to(:lookup) }

  it { is_expected.to route_command('define foo is bar').to(:define) }

  describe '#lookup' do
    before do
      robot.config.handlers.wtf.see_also = []
      send_command('define web is Rails. Rails. Rails.')
      send_command('define &&--88^%!$*() is garbage text')
    end

    it 'responds with the definition of the service' do
      send_command('wtf is web')
      expect(replies.last).to eq('web is Rails. Rails. Rails.')
    end

    it 'responds with the definition of a capitalized service' do
      send_command('wtf is WEB')
      expect(replies.last).to eq('WEB is Rails. Rails. Rails.')
    end

    it 'allows definitions with lots of weird characters' do
      send_command('wtf is &&--88^%!$*()')
      expect(replies.last).to eq('&&--88^%!$*() is garbage text')
    end

    it 'responds with an error if there is no such service' do
      send_command('wtf is foo')
      expect(replies.last).to eq('I don\'t know what foo is, ' \
                                 'type: define foo is <description> to set it.')
    end
  end

  describe 'with urbandictionary enabled' do
    before do
      robot.config.handlers.wtf.see_also = ['urbandictionary']
    end

    it 'responds with see also text' do
      grab_request('get', 200, File.read('spec/files/urban'))
      send_command('wtf is foo')
      expect(replies).to include('According to UrbanDictionary, foo is an term used ' \
                                 'for unimportant variables in programming when the ' \
                                 'programmer is too lazy to think of an actual name.  ' \
                                 'The origin of such word is described in detail in ' \
                                 "[RFC] 3092.\nTo replace this with our own " \
                                 'definition, type: define foo is <description>.')
    end

    it 'responds with just the define statement if there is nothing to look up' do
      grab_request('get', 200, '') # Yes, the API returns a 200 on not found. Sigh.
      send_command('wtf is asdkjfal')
      expect(replies.last).to eq('I don\'t know what asdkjfal is, ' \
                                 'type: define asdkjfal is <description> to set it.')
    end
  end

  describe 'with merriam enabled' do
    before do
      robot.config.handlers.wtf.see_also = ['merriam']
      robot.config.handlers.wtf.api_keys['merriam'] = ENV['MERRIAM_KEY']
    end

    it 'responds with see also text' do
      grab_request('get', 200, File.read('spec/files/merriam'))
      send_command('wtf is foo')
      expect(replies).to include('According to Merriam-Webster Collegiate Dictionary, ' \
                                 'foo is a mythical lion-dog used as a decorative ' \
                                 "motif in Far Eastern art\nTo replace this with our " \
                                 'own definition, type: define foo is <description>.')
    end

    it 'responds with just the define statement if there is nothing to look up' do
      grab_request('get', 200, '') # Yes, the API returns a 200 on not found. Sigh.
      send_command('wtf is asdkjfal')
      expect(replies.last).to eq('I don\'t know what asdkjfal is, ' \
                                 'type: define asdkjfal is <description> to set it.')
    end

    it 'responds with just the define statement if there is a fetch error' do
      grab_request('get', 500, nil)
      send_command('wtf is asdkjfal')
      expect(replies.last).to eq('I don\'t know what asdkjfal is, ' \
                                 'type: define asdkjfal is <description> to set it.')
    end

    it 'responds with just the define statement if there is a parse error' do
      grab_request('get', 200, 'wha?')
      send_command('wtf is asdkjfal')
      expect(replies.last).to eq('I don\'t know what asdkjfal is, ' \
                                 'type: define asdkjfal is <description> to set it.')
    end
  end
end
