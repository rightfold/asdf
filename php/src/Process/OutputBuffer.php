<?php
declare(strict_types = 1);

namespace Process;

final class OutputBuffer
{
    /** @var int */
    public $status;

    /** @var string */
    public $stdout;

    public function __construct(int $status, string $stdout)
    {
        $this->status = $status;
        $this->stdout = $stdout;
    }
}
