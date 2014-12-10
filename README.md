# lita-dig

[![Build Status](https://img.shields.io/travis/esigler/lita-wtf/master.svg)](https://travis-ci.org/esigler/lita-wtf)
[![MIT License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://tldrlegal.com/license/mit-license)
[![RubyGems :: RMuh Gem Version](http://img.shields.io/gem/v/lita-wtf.svg)](https://rubygems.org/gems/lita-wtf)
[![Coveralls Coverage](https://img.shields.io/coveralls/esigler/lita-wtf/master.svg)](https://coveralls.io/r/esigler/lita-wtf)
[![Code Climate](https://img.shields.io/codeclimate/github/esigler/lita-wtf.svg)](https://codeclimate.com/github/esigler/lita-wtf)
[![Gemnasium](https://img.shields.io/gemnasium/esigler/lita-wtf.svg)](https://gemnasium.com/esigler/lita-wtf)

A user-controlled dictionary plugin for [Lita](https://github.com/jimmycuadra/lita).

## Installation

Add lita-wtf to your Lita instance's Gemfile:

``` ruby
gem "lita-wtf"
```

## Configuration

None

## Usage

Set up an entry:

```
lita define foo is something that you want to have defined
> foo is something that you want to have defined
```

Find an entry:

```
lita wtf is foo
> foo is something that you want to have defined
```

## License

[MIT](http://opensource.org/licenses/MIT)
