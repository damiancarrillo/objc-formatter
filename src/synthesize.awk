#! /usr/bin/env awk -f

{
    if ($0 ~ /^[ \t]*@synthesize/ || $0 == "\n") {
        # @start-fragment body
        formatSynthesizeStatements()
        # @end-fragment body
    }
}

# @start-fragment functions
function formatSynthesizeStatements() {
    i = 1
    i = storeSynthesizedProperty(names, aliases, i)

    while (getline) {
        if ($0 ~ /^[ \t]*@synthesize/ || $0 == "\n") {
            i = storeSynthesizedProperty(names, aliases, i)
        } 
        else {
            maxNameLength = 0

            for (j = 1; j < i; j++) {
                maxNameLength = max(maxNameLength, length(names[j]))
            }

            format = "@synthesize %-" maxNameLength "s = %s;\n"

            for (j = 1; j < i; j++) {
                printf(format, names[j], aliases[j])
            }

            break
        }
    }
}

function storeSynthesizedProperty(names, aliases, i) {
    sub("@synthesize", "", $0)
    sub(";", "", $0)

    declarationCount = split($0, declarations,  ",")

    for (j = 1; j <= declarationCount; j++) {
        if (split(declarations[j], values, "=") < 2) {
            sub(" ", "", values[1])
            names[i] = values[1]
            aliases[i] = values[1]
        }
        else {
            sub(" ", "", values[1])
            sub(" ", "", values[2])

            names[i] = values[1]
            aliases[i] = values[2]
        }

        i++
    }

    return i
}

# @end-fragment functions

function max(m, n) {
    return m > n ? m : n
}