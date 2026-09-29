# ~/.config/fish/conf.d/google-cloud-sdk.fish

set sdk_path '/opt/homebrew/Caskroom/gcloud-cli/latest/google-cloud-sdk'

if test -f $sdk_path/path.fish.inc
    source $sdk_path/path.fish.inc
end
