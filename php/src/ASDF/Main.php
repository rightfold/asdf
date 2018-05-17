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
        $handlers = [
            '/list-ledger' => new UseCaseHandler('list-ledger', ['group']),
        ];

        $handler = $handlers['/list-ledger'];

        $request = Request::createFromGlobals();
        $response = $handler->handleRequest($request);
        $response->send();
    }
}
