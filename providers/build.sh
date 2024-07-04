# script which builds every provider in the providers directory
# the provicers are being built using zip and calling them a .jar file
# the .jar file is then being moved to the output directory
mkdir /output
for provider in /providers/*; do
  if [ -d "$provider" ]; then
    provider_name=$(basename "$provider")
    cd "$provider"
    zip -r "$provider_name.jar" ./
    mv "$provider_name.jar" /output/
  fi
done
