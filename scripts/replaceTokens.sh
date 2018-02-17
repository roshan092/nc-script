#!/usr/bin/env bash

input_file=$1
properties_file=$2
output_file=$3

echo "Input file: " ${input_file}
echo "Properties file:" ${properties_file}
echo "Output file:" ${output_file}

properties=()
if [ -f "${properties_file}" ]; then
  echo "${properties_file} found."
  while IFS='=' read -r key value; do
    key=$(echo ${key} | tr '.' '_')
    eval "${key}='${value}'"
    properties+=(${key})
  done < "${properties_file}"
else
  echo "Properties file ${properties_file} not found."
  exit 1
fi

if [ -f "${input_file}" ]; then
  output_dir=$( dirname "${output_file}" )
  echo "Output Directory: " ${output_dir}
  mkdir -p "${output_dir}"
  cp ${input_file} ${output_file}
  echo "Setting properties:--->"
  for property_key in "${properties[@]}"; do
    eval "property_value=\${${property_key}}"
    echo "${property_key} = ${property_value}"
    sed -i "s/\[\[${property_key}\]\]/${property_value}/g" ${output_file}
  done
else
  echo "Input file ${input_file} not found."
  exit 1
fi
