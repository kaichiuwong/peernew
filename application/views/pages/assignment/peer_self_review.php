<table class="table table-sm table-head-fixed table-hover">
    <thead>
        <tr>
            <th class="align-text-top">No.</th>
            <th class="align-text-top" style="width: 50%">Question</th>
            <th class="align-text-top" style="width: 40%">Answer</th>
        </tr>
    </thead>
    <tbody>
        <?php if (empty($assignment_questions_self)) : ?>
            <tr><td colspan="3" class="text-muted">*** No self evaluation questions defined from this assignment ***</td></tr>
        <?php else: ?>
        <?php foreach($assignment_questions_self as $a): ?>
        <tr>
            <td>
                <span class="text-bold">Q<?php echo $a['question_order'];?>.</span>
            </td>
            <td class="text-justify"><?php echo $a['question']; ?></td>
            <?php switch ($a['answer_type']):
                case "SCALE": ?>
                <td>
                    <select name="self_feedback_<?php echo $a['qid']; ?>"  class="form-control form-control-sm score" disabled>
                    <option value="" disabled <?php echo empty($a['feedback'])?"selected": ""; ?>></option>
                    <option value="4" <?php echo ($a['feedback'] == "4")?"selected": ""; ?>>4 - Always</option>
                    <option value="3" <?php echo ($a['feedback'] == "3")?"selected": ""; ?>>3 - Nearly Always</option>
                    <option value="2" <?php echo ($a['feedback'] == "2")?"selected": ""; ?>>2 - Usually</option>
                    <option value="1" <?php echo ($a['feedback'] == "1")?"selected": ""; ?>>1 - Sometimes</option>
                    <option value="0" <?php echo ($a['feedback'] == "0")?"selected": ""; ?>>0 - Seldom</option>
                    </select>
                </td>
            <?php break; ?>
            <?php case "GRADE": ?>
                <td>
                    <select name="self_feedback_<?php echo $a['qid']; ?>"  class="form-control form-control-sm grade" disabled>
                    <option value="" disabled <?php echo empty($a['feedback'])?"selected": ""; ?>></option>
                    <option value="HD" <?php echo ($a['feedback'] == "HD")?"selected": ""; ?>>HD</option>
                    <option value="DN" <?php echo ($a['feedback'] == "DN")?"selected": ""; ?>>DN</option>
                    <option value="CR" <?php echo ($a['feedback'] == "CR")?"selected": ""; ?>>CR</option>
                    <option value="PP" <?php echo ($a['feedback'] == "PP")?"selected": ""; ?>>PP</option>
                    <option value="NN" <?php echo ($a['feedback'] == "NN")?"selected": ""; ?>>NN</option>
                    </select>
                </td>
            <?php break; ?>
            <?php case "SCORE": ?>
                <td class='text-muted bg-light'>
                    <?php echo html_escape($a['feedback']); ?>
                </td>
            <?php break; ?>
            <?php default: ?>
                <td class='text-muted bg-light'>
                    <?php echo html_escape($a['feedback']); ?>
                </td>
            <?php break; ?>
            <?php endswitch; ?>
        </tr>
        <?php endforeach; ?>
        <?php endif; ?>
    </tbody>
</table>