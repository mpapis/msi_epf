# MSI EPF USB

ruby gem to handle MSI EPF USB

## API

    sudo ruby -Ilib/ -r'msi_epf/device' -ryaml -e 'puts MsiEpf::Device.new.version'
    sudo ruby -Ilib/ -r'msi_epf/device' -ryaml -e 'puts MsiEpf::Device.new.name'
    sudo ruby -Ilib/ -r'msi_epf/device' -ryaml -e 'puts MsiEpf::Device.new.mode'
    sudo ruby -Ilib/ -r'msi_epf/device' -ryaml -e 'puts MsiEpf::Device.new.mode=:audio'
    sudo ruby -Ilib/ -r'msi_epf/device' -ryaml -e 'puts MsiEpf::Device.new.leds=[:side, :front]'

Supported modes: `:disabled, :blink, :audio, :breath, :demo, :always` - only one
Supported leds: `:front, :back, :side` - array - all, any or none

# Copyright

Copyright (C) 2013  Michal Papis <mpapis@gmail.com>
License text: GNU-AGPL-3.0.txt
