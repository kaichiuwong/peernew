<form class="form-horizontal" id="self_feedback_form">
<table class="table table-sm table-head-fixed table-hover">
    <thead>
        <tr>
            <th>No.</th>
            <th style="width: 50%">Question</th>
            <th style="width: 40%">Answer</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach($assignment_questions_self as $a): ?>
        <tr>
            <td>
                <span class="text-bold">Q<?php echo $a['question_order'];?>.</span>
                <input type="hidden" name="self_feedback_id_<?php echo $a['id']; ?>" value="" />
            </td>
            <td class="text-justify"><?php echo $a['question']; ?></td>
            <?php switch ($a['answer_type']):
                case "SCALE": ?>
                <td>
                    <select name="self_feedback_<?php $a['id']; ?>"  class="form-control" required>
                    <option value="" disabled selected>-- Select --</option>
                    <option value="4">4 - Always</option>
                    <option value="3">3 - Nearly Always</option>
                    <option value="2">2 - Usually</option>
                    <option value="1">1 - Sometimes</option>
                    <option value="0">0 - Seldom</option>
                    </select>
                </td>
            <?php break; ?>
            <?php case "GRADE": ?>
                <td>
                    <select name="<?php $a['id']; ?>"  class="form-control" required>
                    <option value="" disabled selected>-- Select --</option>
                    <option value="HD">HD</option>
                    <option value="DN">DN</option>
                    <option value="CR">CR</option>
                    <option value="PP">PP</option>
                    <option value="NN">NN</option>
                    </select>
                </td>
            <?php break; ?>
            <?php case "SCORE": ?>
                <td>
                    <input type="number" min="0" max="100" step="1" value=""  name="<?php $a['id']; ?>" class="form-control" required/>
                </td>
            <?php break; ?>
            <?php default: ?>
                <td>
                    <input type="text" name="<?php $a['id']; ?>" class="form-control" required/>
                </td>
            <?php break; ?>
            <?php endswitch; ?>
        </tr>
        <?php endforeach; ?>
    </tbody>
</table>
<?php echo form_close(); ?>