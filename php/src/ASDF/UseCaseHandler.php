<?php
declare(strict_types = 1);

namespace ASDF;

use Process\Command;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * A handler that invokes a use case written in COBOL.
 */
final class UseCaseHandler implements Handler
{
    /** @var string */
    private $path;

    /** @var array<string> */
    private $parameters;

    /**
     * @param string $path
     *     The path to the the COBOL program that implements the use case.
     *
     * @param array<string> $parameters
     *     The names of the fields to read from the request body and turn into
     *     command-line arguments to the COBOL program.
     */
    public function __construct(string $path, array $parameters) {
        $this->path = $path;
        $this->parameters = $parameters;
    }

    public function handleRequest(Request $request): Response {
        $command = new Command($this->path);

        foreach ($this->parameters as $parameter)
        {
            $argument = (string)$request->query->get($parameter);
            $command->arguments[] = $argument;
        }

        $output = $command->buffer();
        return new Response(\serialize($output));
    }
}
