<?php
declare(strict_types = 1);

namespace ASDF;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * A handler that invokes a use case written in COBOL.
 */
final class UseCaseHandler implements Handler
{
    /** @var string */
    private $useCase;

    /** @var array<string> */
    private $parameters;

    /**
     * @param string $useCase
     *     The name of the use case, which will be used to find the COBOL
     *     program that implements it.
     *
     * @param array<string> $parameters
     *     The names of the fields to read from the request body and turn into
     *     command-line arguments to the COBOL program.
     */
    public function __construct(string $useCase, array $parameters) {
        $this->useCase = $useCase;
        $this->parameters = $parameters;
    }

    public function handleRequest(Request $request): Response {
        return new Response(\serialize($this));
    }
}
