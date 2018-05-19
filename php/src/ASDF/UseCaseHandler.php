<?php
declare(strict_types = 1);

namespace ASDF;

use Process\Command;
use Process\OutputBuffer;

use Symfony\Component\HttpFoundation\ParameterBag;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * A handler that invokes a use case written in COBOL.
 */
abstract class UseCaseHandler implements Handler
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
     *     The names of the fields to read from the parameter bag and turn into
     *     command-line arguments to the COBOL program.
     */
    protected function __construct(string $path, array $parameters)
    {
        $this->path = $path;
        $this->parameters = $parameters;
    }

    /**
     * Return the parameter bag to read the arguments from.
     */
    protected abstract function parameterBag(Request $request): ParameterBag;

    /**
     * Postprocess the output of the COBOL program and return a response.
     */
    protected abstract function postprocess(OutputBuffer $output): Response;

    public function handleRequest(Request $request): Response
    {
        $command = new Command($this->path);

        $parameterBag = $this->parameterBag($request);
        foreach ($this->parameters as $parameter)
        {
            $argument = (string)$parameterBag->get($parameter);
            $command->arguments[] = $argument;
        }

        $output = $command->buffer();
        return $this->postprocess($output);
    }
}
