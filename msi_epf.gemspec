#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

# Copyright (C) 2013  Michal Papis <mpapis@gmail.com>
# License text: GNU-AGPL-3.0.txt

Kernel.load File.expand_path("../lib/msi_epf/version.rb", __FILE__)

Gem::Specification.new do |s|
  s.name        = "msi_epf"
  s.version     = MsiEpf::VERSION
  s.authors     = ["Michal Papis"]
  s.email       = ["mpapis@gmail.com"]
  s.homepage    = "http://github.com/mpapis/msi_epf"
  s.summary     = %q{MSI EPF USB handler}
  s.license     = 'GNU-AGPL-3.0.txt'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.add_dependency "libusb"
  #s.add_development_dependency "smf-gem"
end
