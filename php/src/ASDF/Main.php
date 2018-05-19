<?php
declare(strict_types = 1);

namespace ASDF;

use Symfony\Component\HttpFoundation\Request;

final class Main
{
    private function __construct()
    {
    }

    public static function main(): void
    {
        $buildPath = __DIR__ . '/../../../build/cobol/src';

        $handlers = [
            '/list-ledger' => new ListLedger\Handler($buildPath),
        ];

        $handler = $handlers['/list-ledger'];

        $request = Request::createFromGlobals();
        $response = $handler->handleRequest($request);
        $response->send();
    }
}
