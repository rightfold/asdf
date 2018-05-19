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
            <form action="/append-to-ledger" method="post">
                <input type="hidden" name="group" value="<?php echo \htmlentities($group); ?>">
                <select name="type">
                    <option value="D">Debt</option>
                    <option value="P">Payment</option>
                </select>
                <textarea name="comment"></textarea>
                <input type="text" name="debitor">
                <input type="text" name="creditor">
                <input type="number" name="amount">
                <button type="submit">Submit</button>
            </form>
        <?php
        MasterTemplate::renderFooter();
    }
}
