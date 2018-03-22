/usr/local/bin/ykman oath code 2>/dev/null | grep {query} | perl -lne '
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

