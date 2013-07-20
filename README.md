# MSI EPF USB

ruby gem to handle MSI EPF USB

## API

    sudo ruby -Ilib/ -r'msi_epf/device' -e 'puts MsiEpf::Device.new.version'
    sudo ruby -Ilib/ -r'msi_epf/device' -e 'puts MsiEpf::Device.new.name'
    sudo ruby -Ilib/ -r'msi_epf/device' -e 'puts MsiEpf::Device.new.mode'
    sudo ruby -Ilib/ -r'msi_epf/device' -e 'puts MsiEpf::Device.new.mode=:audio'
    sudo ruby -Ilib/ -r'msi_epf/device' -e 'puts MsiEpf::Device.new.state'
    sudo ruby -Ilib/ -r'msi_epf/device' -e 'puts MsiEpf::Device.new.state=:enable'
    sudo ruby -Ilib/ -r'msi_epf/device' -e 'puts MsiEpf::Device.new.leds=[:side, :front]'

Supported states: `:disabled, :enabled` - only one, does not change mode.

Supported modes: `:disabled, :blink, :audio, :breath, :demo, :always` - only one, does change state.

Supported leds: `:front, :back, :side` - array - all, any or none.

There is no read for leds - not sure if it's even supported on interface level.

# Copyright

Copyright (C) 2013  Michal Papis <mpapis@gmail.com>
License text: GNU-AGPL-3.0.txt

# Thanks to

- https://github.com/aljen/gtlm
