# lita-wtf

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

Optionally, you can add 'See Also' handlers

```
lita.config.wtf.see_also = ['merriam', 'urbandictionary']
lita.config.wtf.api_keys = {
  'merriam': 'abc123'
}
```

## Usage

Set an entry:

```
lita define foo is something that you want to have defined
> foo is something that you want to have defined
```

Find an entry:

```
lita wtf is foo
> foo is something that you want to have defined
```

Optionally, get 'See Also' recommendations:

```
lita wtf is foo
> According to Merriam-Webster Collegiate Dictionary,
> foo is a mythical lion-dog used as a decorative motif
> in Far Eastern art
> To replace this with our own definition, type: define foo is <description>.
```

## Development

This project uses dotenv to load sensitive variables for development.  Create
a .env file in your local copy with "MERRIAM_KEY=<whatever key you use>"
