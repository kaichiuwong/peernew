<div class="alert alert-<?php echo $submission_condition['result']? "success" : "danger" ; ?>" role="alert">
    <?php if ($submission_condition['result']): ?>
        <span class='text-bold'><?php echo $submission_condition['close_desc'] ;?></span>: <?php echo $submission_condition['close_date'] ;?> 
    <?php else: ?>
        <?php echo $submission_condition['result']? "":"<span class='text-bold'><i class='fas fa-exclamation-triangle'></i> This section is closed for changes.</span><br />" ;?>
        <?php echo $submission_condition['open_date']? $submission_condition['open_desc']. ": ".$submission_condition['open_date']."<br />" : "" ; ?>
        <?php echo $submission_condition['close_date']? $submission_condition['close_desc']. ": ".$submission_condition['close_date'] : "" ; ?>
    <?php endif; ?>
</div>
<?php if ($submission_condition['result']): ?>
    <?php echo form_open('assignment/self_feedback_form/'.$asg_id.'/'.$topic_id,array("class"=>"form-horizontal", "id"=>"self_feedback_form")); ?>
<?php else: ?>
    <form class="form-horizontal">
<?php endif; ?>
<fieldset <?php echo $submission_condition['result']? "" : 'disabled="disabled"' ; ?>>
    <input type="hidden" name="asg_id" value="<?php echo $asg_id; ?>" />
    <input type="hidden" name="topic_id" value="<?php echo $topic_id; ?>" />
    <input type="hidden" name="reviewer" value="<?php echo encode_id($username); ?>" />
    <input type="hidden" name="reviewee" value="<?php echo encode_id($username); ?>" />
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
            <?php $encode_qid = encode_id($a['qid']);?>
            <tr>
                <td>
                    <span class="text-bold">Q<?php echo $a['question_order'];?>.</span>
                    <input type="hidden" name="self_feedback_id_<?php echo $encode_qid; ?>" value="<?php echo ($a['id'])?encode_id($a['id']):""; ?>" />
                    <input type="hidden" name="question_id[]" value="<?php echo $encode_qid; ?>" />
                </td>
                <td class="text-justify"><?php echo $a['question']; ?></td>
                <?php switch ($a['answer_type']):
                    case "SCALE": ?>
                    <td>
                        <select name="self_feedback_<?php echo $encode_qid; ?>"  class="form-control form-control-sm score" required>
                        <option value="" disabled <?php echo empty($a['feedback'])?"selected": ""; ?>>-- Select --</option>
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
                        <select name="self_feedback_<?php echo $encode_qid; ?>"  class="form-control form-control-sm grade" required>
                        <option value="" disabled <?php echo empty($a['feedback'])?"selected": ""; ?>>-- Select --</option>
                        <option value="HD" <?php echo ($a['feedback'] == "HD")?"selected": ""; ?>>HD</option>
                        <option value="DN" <?php echo ($a['feedback'] == "DN")?"selected": ""; ?>>DN</option>
                        <option value="CR" <?php echo ($a['feedback'] == "CR")?"selected": ""; ?>>CR</option>
                        <option value="PP" <?php echo ($a['feedback'] == "PP")?"selected": ""; ?>>PP</option>
                        <option value="NN" <?php echo ($a['feedback'] == "NN")?"selected": ""; ?>>NN</option>
                        </select>
                    </td>
                <?php break; ?>
                <?php case "SCORE": ?>
                    <td>
                        <input type="number" min="0" max="100" step="1" value=""  name="self_feedback_<?php echo $encode_qid; ?>" value="<?php echo html_escape($a['feedback']); ?>" class="form-control form-control-sm" required/>
                    </td>
                <?php break; ?>
                <?php default: ?>
                    <td>
                        <input type="text" name="self_feedback_<?php echo $encode_qid; ?>" class="form-control form-control-sm" value="<?php echo html_escape($a['feedback']); ?>" required/>
                    </td>
                <?php break; ?>
                <?php endswitch; ?>
            </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
</fieldset>
<?php echo form_close(); ?>