<?php
declare(strict_types = 1);

namespace Process;

final class Command
{
    /** @var string */
    public $path;

    /** @var array<string> */
    public $arguments;

    public function __construct(string $path)
    {
        $this->path = $path;
        $this->arguments = [];
    }

    /**
     * Run the command and return its output.
     */
    public function buffer(): OutputBuffer
    {
        $commandSegments = \array_merge([$this->path], $this->arguments);
        $command = \implode(' ', \array_map('escapeshellarg', $commandSegments));
        $fds = [1 => ['pipe', 'w']];
        $proc = \proc_open($command, $fds, $pipes);

        $stdout = \stream_get_contents($pipes[1]);
        \fclose($pipes[1]);

        $status = \proc_close($proc);

        return new OutputBuffer($status, $stdout);
    }
}
