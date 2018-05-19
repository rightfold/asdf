<?php
declare(strict_types = 1);

namespace ASDF\ListLedger;

use ASDF\IterableExtras;
use ASDF\StringExtras;
use ASDF\UseCaseHandler;

use Process\OutputBuffer;

use Symfony\Component\HttpFoundation\ParameterBag;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\StreamedResponse;

final class Handler extends UseCaseHandler
{
    public function __construct(string $buildPath)
    {
        parent::__construct("$buildPath/asdf-list-ledger.cob.out", ['group']);
    }

    protected function parameterBag(Request $request): ParameterBag
    {
        return $request->query;
    }

    protected function postprocess(OutputBuffer $output): Response
    {
        return new StreamedResponse(
            function() use($output): void
            {
                $lines = IterableExtras::map(
                    StringExtras::lines($output->stdout),
                    /** @return array<string> */
                    function(string $line): array
                    {
                        return \explode("\t", $line);
                    }
                );
                Template::render($lines);
            }
        );
    }
}
