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

        /** @var array<string,array<string,Handler>> */
        $handlers = [
            '/append-to-ledger' => [
                'GET' => AppendToLedger\FormHandler::instance(),
            ],
            '/list-ledger' => [
                'GET' => new ListLedger\Handler($buildPath),
            ],
        ];

        $handler = $handlers[(string)$_SERVER['PATH_INFO']]
                            [(string)$_SERVER['REQUEST_METHOD']];

        $request = Request::createFromGlobals();
        $response = $handler->handleRequest($request);
        $response->send();
    }
}
