# perl-remote-exec
execute perl code on remote server withouth copying source code (Perl code is eval-ved on remote server)

# Example
```bash
./perl-remote-exec.pl root@server ./test-print-args.pl a b c d
```
```
OUTPUT: '$VAR1 = {
          'args' => [
                      'a',
                      'b',
                      'c',
                      'd'
                    ],
          'command' => '-e'
        };
'
```

Notice: you don't need to copy perl scripts to remote server

## background
The following command is executed:
```bash
ssh root@server perl -MMIME::Base64 \
  -e "\"eval decode_base64 qw=c3ViIGxvYWQgeyBldmFsKGRlY29kZV9iYXNlNjQoc2hpZnQpKTsgaWYgKCRAKSB7IHByaW50ICJ7IFwiZXJyb3JcIjogXCIkQFwiIH0iOyB9IGVsc2UgeyBydW4oQF8pOyB9IH0=; load(@ARGV);\"" \
    "IyEvdXNyL2Jpbi9wZXJsIC13Cgp1c2Ugc3RyaWN0Owp1c2UgRGF0YTo6RHVtcGVyOwoKc3ViIHJ1bihAKQp7IAoJcHJpbnQgRHVtcGVyKHsgY29tbWFuZCA9PiAkMCwgYXJncyA9PiBcQF8gfSk7Cn0KCg==" \
    a b c d
```

