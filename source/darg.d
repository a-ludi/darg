/**
 * Copyright: Copyright Jason White, 2015
 * License:   MIT
 * Authors:   Jason White
 *
 * Description:
 * Parses arguments.
 */
module argparse;

/**
 * Generic argument parsing exception.
 */
class ArgParseException : Exception
{
    this(string msg) pure nothrow
    {
        super(msg);
    }
}

/**
 * Specifies that an option is not optional.
 */
enum Required;

/**
 * User defined attribute for an option.
 */
struct Option
{
    string[] names;

    this(string[] names...)
    {
        this.names = names;
    }
}

/**
 * User defined attribute for a positional argument.
 */
struct Argument
{
    /**
     * Name of the argument. Since this is a positional argument, this value is
     * only used in the help string.
     */
    string name;

    /**
     * Lower and upper bounds for the number of values this argument can have.
     * Note that these bounds are inclusive (i.e., [lowerBound, upperBound]).
     */
    size_t lowerBound = 1;
    size_t upperBound = 1; /// Ditto

    /**
     * Constructor.
     */
    this(string name, size_t lowerBound = 1, size_t upperBound = 1) pure nothrow
    {
        // TODO: Check if the name has spaces. (Replace with a dash?)
        this.name = name;
        this.lowerBound = lowerBound;
        this.upperBound = upperBound;
    }

    /**
     * Convenience constructor with an argument multiplicity specifier.
     */
    this(string name, char multiplicity) pure
    {
        this.name = name;

        switch (multiplicity)
        {
            case '?':
                this.lowerBound = 0;
                this.upperBound = 1;
                break;
            case '*':
                this.lowerBound = 0;
                this.upperBound = size_t.max;
                break;
            case '+':
                this.lowerBound = 1;
                this.upperBound = size_t.max;
                break;
            default:
                throw new ArgParseException(
                        "Invalid argument multiplicity specifier:"
                        " must be either '?', '*', or '+'"
                        );
        }
    }
}

unittest
{
    with (Argument("lion"))
    {
        assert(name == "lion");
        assert(lowerBound == 1);
        assert(upperBound == 1);
    }

    with (Argument("tiger", '?'))
    {
        assert(lowerBound == 0);
        assert(upperBound == 1);
    }

    with (Argument("bear", '+'))
    {
        assert(lowerBound == 1);
        assert(upperBound == size_t.max);
    }

    with (Argument("dinosaur", '*'))
    {
        assert(lowerBound == 0);
        assert(upperBound == size_t.max);
    }
}

unittest
{
    import std.exception : collectException;

    assert(collectException!ArgParseException(Argument("fails", 'q')));
    assert(!collectException!ArgParseException(Argument("success", '?')));
    assert(!collectException!ArgParseException(Argument("success", '*')));
    assert(!collectException!ArgParseException(Argument("success", '+')));
}

/**
 * Help string for an option or positional argument.
 */
struct Help
{
    string help;
}

/**
 * Constructs a printable usage string at compile time from the given options
 * structure.
 */
string usageString(Options)(string program) pure nothrow
{
    return "TODO";
}

/**
 * Constructs a printable help string at compile time for the given options
 * structure.
 */
string helpString(Options)() pure nothrow
{
    return "TODO";
}

/**
 * Thrown when parsing arguments fails.
 */
class ArgParseError : Exception
{
    this(string msg)
    {
        super(msg);
    }
}

/**
 * Parses options from the given list of arguments. Note that the first argument
 * is assumed to be the program name and is ignored.
 *
 * Returns: Options structure filled out with values.
 *
 * Throws: ArgParseException if arguments are invalid.
 */
Options parseArgs(Options)(string[] args) pure
{
    Options options;

    return options;
}

/// Ditto
unittest
{
    struct Options
    {
        @Option("help")
            @Help("Prints help on command line arguments.")
            bool help;

        @Argument("path", 'q')
            @Help("Path to the build description.")
            string path;

        @Option("dryrun", "n")
            @Help("Don't make any functional changes. Just print what might"
                  " happen.")
            bool dryRun;

        @Option("threads", "j")
            @Help("The number of threads to use. Default is the number of"
                  " logical cores.")
            string threads;

        @Option("color")
            @Help("When to colorize the output.")
            string color = "auto";

        @Option("add")
            @Required
            @Help("Adds the given number to a running total.")
            void add(string num)
            {
                import std.conv : to;
                sum += num.to!int;
            }

        int sum;
    }
}

