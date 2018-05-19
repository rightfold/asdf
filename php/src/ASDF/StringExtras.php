<?php
declare(strict_types = 1);

namespace ASDF;

use Generator;

final class StringExtras
{
    private function __construct()
    {
    }

    /**
     * Yield the lines of a string. This is different from exploding the
     * string, because this does not include a final empty string if the string
     * ends with a line terminator.
     *
     * The yold lines do not include the line terminator.
     *
     * @return Generator<int,string>
     */
    public static function lines(string $s): Generator
    {
        $file = \fopen('php://memory', 'r+');
        \fputs($file, $s);
        \rewind($file);
        while (($line = \fgets($file)) !== FALSE)
        {
            yield \rtrim($line, "\n");
        }
    }
}
