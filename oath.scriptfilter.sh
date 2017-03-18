/usr/local/bin/yubioath show {query} 2>/dev/null | perl -lne '
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

