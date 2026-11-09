#!/bin/sh
# Prints a USERCOLORS file (see config.mk) with a row for every login user
# of this machine (uid >= 1000 with a login shell) and example colors.

# name, fg, bg: one combination per line
palette='ocean #eeeeee #005577
brick #eeeeee #7a2e2e
forest #eeeeee #2e5e3a
plum #eeeeee #6b4c8a
teal #eeeeee #2e6a6a
raspberry #eeeeee #8a3e6a
slate #eeeeee #4a5a7a
graphite #eeeeee #3a3a3a
mustard #1a1a1a #c9a227
ember #1a1a1a #d9822b
mint #1a1a1a #7fc8a9
sand #1a1a1a #d8c7a0'

getent passwd | awk -F: -v palette="$palette" '
BEGIN { n = split(palette, combos, "\n") }
$3 >= 1000 && $3 < 60000 && $7 !~ /(nologin|false)$/ {
	split(combos[users % n + 1], c, " ")
	user[++users] = $1
	combo[users] = c[1]
	used[c[1]] = 1
}
END {
	print "/* SchemeSel colors per user, compiled into dwm. Rebuild dwm after editing."
	print " * Uncomment a combination to use it in a row. */"
	print ""
	printf "%-43s/* fg         bg         border */\n", ""
	for (i = 1; i <= n; i++) {
		split(combos[i], c, " ")
		printf "%-41s{ \"%s\", \"%s\", \"%s\" };\n", (used[c[1]] ? "" : "// ") "static const char *" c[1] "[] =", c[2], c[3], c[3]
	}
	print ""
	print "static const UserColors usercolors[] = {"
	print "\t/* user        colors */"
	for (i = 1; i <= users; i++)
		printf "\t{ %-13s %s },\n", "\"" user[i] "\",", combo[i]
	print "\t{ NULL },"
	print "};"
}'
