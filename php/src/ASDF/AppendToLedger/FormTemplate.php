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
            <form action="/append-to-ledger?group=<?php echo \htmlentities($group); ?>"
                  method="post">
                <select name="type">
                    <option>Debt</option>
                    <option>Payment</option>
                </select>
                <textarea name="comment">
                </textarea>
                <input type="text" name="debitor">
                <input type="text" name="creditor">
                <input type="number" name="amount" step="0.01">
                <button type="submit">Submit</button>
            </form>
        <?php
        MasterTemplate::renderFooter();
    }
}
