<?php if (sizeof($assignment_topics_member) > 1) : ?>
<?php echo form_open('assignment/peer_feedback_form/'.$asg_id.'/'.$topic_id,array("class"=>"form-horizontal", "id"=>"peer_feedback_form")); ?>
<input type="hidden" name="asg_id" value="<?php echo $asg_id; ?>" />
<input type="hidden" name="topic_id" value="<?php echo $topic_id; ?>" />
<input type="hidden" name="reviewer" value="<?php echo $username; ?>" />
<?php foreach($assignment_topics_member as $member):  ?>
<?php if ($member['user_id'] != $username) :?>
<input type="hidden" name="reviewee[]" value="<?php echo $member['user_id']; ?>" />
<?php $feedback_sum[$member['user_id']] = 0; ?>
<?php endif; ?>
<?php endforeach; ?>
<table class="table table-sm table-head-fixed table-hover">
    <thead>
        <tr>
            <th>No.</th>
            <th style="width: 50%">Question</th>
            <?php foreach($assignment_topics_member as $member) : ?>
            <?php if ($member['user_id'] != $username) :?>
                <th><?php echo $member['first_name']; ?> <?php echo $member['last_name']; ?></th>
            <?php endif; ?>
            <?php endforeach; ?>
        </tr>
    </thead>
    <tbody>
        <?php $idx = 0 ; ?>
        <?php foreach($assignment_questions_peer[array_keys($assignment_questions_peer)[0]] as $a):  ?>
        <tr>
            <td>
                <span class="text-bold">Q<?php echo $a['question_order'];?>.</span>
                <input type="hidden" name="question_id[]" value="<?php echo $a['qid']; ?>" />
            </td>
            <td class="text-justify"><?php echo $a['question']; ?></td>
            <?php foreach($assignment_topics_member as $member):  ?>
            <?php if ($member['user_id'] != $username) :?>
                <?php $feedback = $assignment_questions_peer[$member['user_id']][$idx]['feedback']; ?>
                <?php $feedback_id = $assignment_questions_peer[$member['user_id']][$idx]['id']; ?>
                <input type="hidden" name="feedback_id_<?php echo $member['user_id'].'_'.$a['qid']; ?>" value="<?php echo $feedback_id; ?>" />

                <?php switch ($a['answer_type']):
                    case "SCALE": ?>
                    <?php $feedback_sum[$member['user_id']] += intval($feedback);?>
                    <td>
                        <select name="<?php echo 'feedback_'.$member['user_id'].'_'.$a['qid']; ?>"  class="form-control form-control-sm score score-<?php echo $member['user_id']; ?>" user-name="<?php echo $member['user_id']; ?>" required>
                        <option value="" disabled  <?php echo empty($feedback)?"selected" :""; ?>>-- Select --</option>
                        <option value="4" <?php echo ($feedback == "4")?"selected" :""; ?>>4 - Always</option>
                        <option value="3" <?php echo ($feedback == "3")?"selected" :""; ?>>3 - Nearly Always</option>
                        <option value="2" <?php echo ($feedback == "2")?"selected" :""; ?>>2 - Usually</option>
                        <option value="1" <?php echo ($feedback == "1")?"selected" :""; ?>>1 - Sometimes</option>
                        <option value="0" <?php echo ($feedback == "0")?"selected" :""; ?>>0 - Seldom</option>
                        </select>
                    </td>
                <?php break; ?>
                <?php case "GRADE": ?>
                    <td>
                        <select name="<?php echo 'feedback_'.$member['user_id'].'_'.$a['qid']; ?>"  class="form-control form-control-sm grade grade-<?php echo $member['user_id']; ?>" user-name="<?php echo $member['user_id']; ?>" required>
                        <option value="" disabled <?php echo empty($feedback)?"selected" :""; ?>>-- Select --</option>
                        <option value="HD" <?php echo ($feedback == "HD")?"selected" :""; ?>>HD</option>
                        <option value="DN" <?php echo ($feedback == "DN")?"selected" :""; ?>>DN</option>
                        <option value="CR" <?php echo ($feedback == "CR")?"selected" :""; ?>>CR</option>
                        <option value="PP" <?php echo ($feedback == "PP")?"selected" :""; ?>>PP</option>
                        <option value="NN" <?php echo ($feedback == "NN")?"selected" :""; ?>>NN</option>
                        </select>
                    </td>
                <?php break; ?>
                <?php case "SCORE": ?>
                    <td>
                        <input type="number" min="0" max="100" step="1" value="<?php echo html_escape($feedback); ?>" name="<?php echo 'feedback_'.$member['user_id'].'_'.$a['qid']; ?>" class="form-control form-control-sm" required/>
                    </td>
                <?php break; ?>
                <?php default: ?>
                    <td>
                        <input type="text" value="<?php echo html_escape($feedback); ?>" name="<?php echo 'feedback_'.$member['user_id'].'_'.$a['qid']; ?>" class="form-control form-control-sm" required/>
                    </td>
                <?php break; ?>
                <?php endswitch; ?>
                <?php endif; ?>
            <?php endforeach; ?>
            <?php $idx = $idx + 1; ?>
        </tr>
        <?php endforeach; ?>
    </tbody>
    <tfoot>
        <tr>
            <td></td>
            <td class="text-bold">Total</td>
            <?php foreach($assignment_topics_member as $member): ?>
            <?php if ($member['user_id'] != $username) :?>
                <td class="text-bold" id="sum_<?php echo $member['user_id']; ?>" class="sum sum-<?php echo $member['user_id']; ?>" user-name="<?php echo $member['user_id']; ?>"><?php echo  $feedback_sum[$member['user_id']]; ?></td>
            <?php endif; ?>
            <?php endforeach; ?>
        </tr>
    </tfoot>
</table>
<?php echo form_close(); ?>
<?php endif; ?>