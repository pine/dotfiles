# Configuration file parser

config_get_nth() {
  local str=$1
  local n=$2

  str="${str%%\#*}"
  str="$(echo "$str" | tr -d '[:space:]')"

  echo $(echo "$str" | cut -d ',' -f $((n+1)))
}

config_get_opt() {
  local str=$1
  local name=$2
  local value

  str="${str%%\#*}"
  str="$(echo "$str" | tr -d '[:space:]')"

  value=$(echo "$str" | grep -o -E "(^|,)$name=[[:alnum:]_-]*($|,)")
  value="$(echo "$value" | tr -d ',')"

  echo ${value:$((${#name}+1))}
}
