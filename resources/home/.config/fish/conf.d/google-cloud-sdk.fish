# ~/.config/fish/conf.d/google-cloud-sdk.fish

set sdk_path '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk'

if test -f $sdk_path/path.fish.inc
    source $sdk_path/path.fish.inc
end
