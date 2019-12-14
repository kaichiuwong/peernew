<?php if (sizeof($assignment_topics_member) > 1) : ?>
<?php echo form_open('assignment/peer_feedback_form/'.$asg_id.'/'.$topic_id,array("class"=>"form-horizontal", "id"=>"peer_feedback_form")); ?>
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
        <?php foreach($assignment_questions_peer as $a):  ?>
        <tr>
            <td><span class="text-bold">Q<?php echo $a['question_order'];?>.</span></td>
            <td class="text-justify"><?php echo $a['question']; ?></td>
            <?php foreach($assignment_topics_member as $member):  ?>
            <?php if ($member['user_id'] != $username) :?>
                <?php switch ($a['answer_type']):
                    case "SCALE": ?>
                    <td>
                        <select name="<?php echo 'answer_'.$member['user_id'].'_'.$a['id']; ?>"  class="form-control" data-username="<?php echo $member['user_id']; ?>" required>
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
                        <select name="<?php echo 'answer_'.$member['user_id'].'_'.$a['id']; ?>"  class="form-control <?php echo 'grade_'.$member['user_id']; ?>" required>
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
                        <input type="number" min="0" max="100" step="1" value=""  name="<?php echo 'answer_'.$member['user_id'].'_'.$a['id']; ?>" class="form-control" data-username="<?php echo $member['user_id']; ?>" required/>
                    </td>
                <?php break; ?>
                <?php default: ?>
                    <td>
                        <input type="text" name="<?php echo 'answer_'.$member['user_id'].'_'.$a['id']; ?>" class="form-control" required/>
                    </td>
                <?php break; ?>
                <?php endswitch; ?>
                <?php endif; ?>
            <?php endforeach; ?>
        </tr>
        <?php endforeach; ?>
    </tbody>
    <tfoot>
        <tr>
            <td></td>
            <td class="text-bold">Total</td>
            <?php foreach($assignment_topics_member as $member): ?>
            <?php if ($member['user_id'] != $username) :?>
                <td class="text-bold" id="sum_<?php echo $member['user_id']; ?>">0</td>
            <?php endif; ?>
            <?php endforeach; ?>
        </tr>
    </tfoot>
</table>
<?php echo form_close(); ?>
<?php endif; ?>