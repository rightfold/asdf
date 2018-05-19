<?php
declare(strict_types = 1);

namespace ASDF;

use Generator;

final class IterableExtras
{
    private function __construct()
    {
    }

    /**
     * @template T
     * @template U
     *
     * @param iterable<int,T> $xs
     * @param callable(T):U $f
     * @return Generator<int,U>
     */
    public static function map(iterable $xs, callable $f): Generator
    {
        foreach ($xs as $x)
        {
            yield $f($x);
        }
    }
}
