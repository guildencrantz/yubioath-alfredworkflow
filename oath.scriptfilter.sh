#!/usr/bin/env zsh
pkill -9 scdaemon; # Release yubikey if gpg has it

_QUERY={query}
[[ -n $_QUERY ]] && _QUERY="grep '$_QUERY' |"

[[ -n $YK_SERIAL ]] && YK_SERIAL="-d $YK_SERIAL"

/usr/local/bin/ykman $YK_SERIAL oath accounts code | ${QUERY} perl -lne '
	BEGIN {
		$c=0;
		print "{ \"items\": [";
	};
	{
		if ($c > 0) {
			print ",";
		}
		$c++;

    /(.+?)\s+((\d+)|(\[Requires Touch\]))$/;

    $subtitle = "";
    if ($2 == "[Requires Touch]") {
      $arg = $1;
      $subtitle = ",\"subtitle\": \"Requires Touch\"";
    } else {
      $arg = $2;
    }

		print "{
      \"title\": \"$1\",
      \"arg\": \"$arg\"
      $subtitle
    }";
	};
	END {
		print "]}";
	};
'

