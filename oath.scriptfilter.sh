pkill -9 scdaemon; # Release yubikey if gpg has it
/usr/local/bin/ykman oath accounts code 2>/dev/null | grep {query} | perl -lne '
	BEGIN {
		$c=0;
		print "{ \"items\": [";
	};
	{
		if ($c > 0) {
			print ",";
		}
		$c++;
		/(.+?)(\d+)$/;
		print "{ \"title\": \"$1\", \"arg\": \"$2\" }";
	};
	END {
		print "]}";
	};
'

