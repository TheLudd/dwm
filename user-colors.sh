#!/bin/sh
# Prints a USERCOLORS file (see config.mk) with a row for every login user
# of this machine (uid >= 1000 with a login shell) and example colors.

# name, fg, bg, border: one combination per line; the more intense
# backgrounds get a quieter border
palette='ocean #eeeeee #005577 #005577
slate #eeeeee #4a5a7a #4a5a7a
teal #eeeeee #2e6a6a #2e6a6a
forest #eeeeee #2e5e3a #2e5e3a
graphite #eeeeee #3a3a3a #3a3a3a
brick #eeeeee #7a2e2e #7a2e2e
wine #eeeeee #6a2c3e #6a2c3e
rosewood #eeeeee #8a4a52 #8a4a52
aubergine #eeeeee #4f2f4f #4f2f4f
mauve #eeeeee #7a5470 #7a5470
dusk #eeeeee #5a4a7a #5a4a7a
plum #eeeeee #6b4c8a #5a4e6a
raspberry #eeeeee #8a3e6a #6a4a5e
orchid #eeeeee #9a5a9a #6e5470
ruby #eeeeee #9a3040 #6e3a42
lilac #1a1a1a #c3aed6 #8a7a9a
rose #1a1a1a #d6a8b4 #9a7a84
mustard #1a1a1a #c9a227 #8a7a4a
ember #1a1a1a #d9822b #9a6e4a
mint #1a1a1a #7fc8a9 #5e8a78
sand #1a1a1a #d8c7a0 #9a8e74'

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
		printf "%-41s{ \"%s\", \"%s\", \"%s\" };\n", (used[c[1]] ? "" : "// ") "static const char *" c[1] "[] =", c[2], c[3], c[4]
	}
	print ""
	print "static const UserColors usercolors[] = {"
	print "\t/* user        colors */"
	for (i = 1; i <= users; i++)
		printf "\t{ %-13s %s },\n", "\"" user[i] "\",", combo[i]
	print "\t{ NULL },"
	print "};"
}'
