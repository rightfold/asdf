<?php
declare(strict_types = 1);

namespace ASDF\AppendToLedger;

use ASDF\MasterTemplate;

final class FormTemplate {
    private function __construct()
    {
    }

    public static function render(string $group): void
    {
        MasterTemplate::renderHeader('Append to ledger');
        ?>
            LOL
        <?php
        MasterTemplate::renderFooter();
    }
}
