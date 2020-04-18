<div class="alert alert-<?php echo $submission_condition['result']? "success" : "danger" ; ?>" role="alert">
    <?php if ($submission_condition['result']): ?>
        <span class='text-bold'><?php echo $submission_condition['close_desc'] ;?></span>: <?php echo $submission_condition['close_date'] ;?> 
    <?php else: ?>
        <?php echo $submission_condition['result']? "":"<span class='text-bold'><i class='fas fa-exclamation-triangle'></i> This section is closed for changes.</span><br />" ;?>
        <?php echo $submission_condition['open_date']? $submission_condition['open_desc']. ": ".$submission_condition['open_date']."<br />" : "" ; ?>
        <?php echo $submission_condition['close_date']? $submission_condition['close_desc']. ": ".$submission_condition['close_date'] : "" ; ?>
    <?php endif; ?>
</div>
<?php if (sizeof($assignment_topics_member) > 1) : ?>
<?php if ($submission_condition['result']): ?>
    <?php echo form_open('assignment/peer_feedback_form/'.$asg_id.'/'.$topic_id,array("class"=>"form-horizontal", "id"=>"peer_feedback_form")); ?>
<?php else: ?>
    <form class="form-horizontal">
<?php endif; ?>
<fieldset <?php echo $submission_condition['result']? "" : 'disabled="disabled"' ; ?>>
    <input type="hidden" name="asg_id" value="<?php echo $asg_id; ?>" />
    <input type="hidden" name="topic_id" value="<?php echo $topic_id; ?>" />
    <input type="hidden" name="reviewer" value="<?php echo encode_id($username); ?>" />
    <?php foreach($assignment_topics_member as $member):  ?>
    <?php if ($member['user_id'] != $username) :?>
    <input type="hidden" name="reviewee[]" value="<?php echo encode_id($member['user_id']); ?>" />
    <?php $feedback_sum[$member['user_id']] = 0; ?>
    <?php endif; ?>
    <?php endforeach; ?>
    <div class="table-responsive">
        <table class="table table-sm table-head-fixed table-hover">
            <thead>
                <tr>
                    <th>No.</th>
                    <th style="width: 50%">Question</th>
                    <?php foreach($assignment_topics_member as $member) : ?>
                    <?php if ($member['user_id'] != $username) :?>
                        <th>
                        <a href="javascript:void(0);" data-title="Self Evaluation Feedback of " data-username="<?php echo $member['first_name']; ?> <?php echo $member['last_name']; ?>" data-href="<?php echo site_url('assignment/peer_self_review/'.$asg_id.'/'.$topic_id.'/'.encode_id($member['user_id']) ); ?>" class="peer_mark_open">
                            <?php echo $member['first_name']; ?> <?php echo $member['last_name']; ?>
                        </a>
                        </th>
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
                        <input type="hidden" name="question_id[]" value="<?php echo encode_id($a['qid']); ?>" />
                    </td>
                    <td class="text-justify"><?php echo $a['question']; ?></td>
                    <?php foreach($assignment_topics_member as $member):  ?>
                    <?php if ($member['user_id'] != $username) :?>
                        <?php $feedback = $assignment_questions_peer[$member['user_id']][$idx]['feedback']; ?>
                        <?php $feedback_id = $assignment_questions_peer[$member['user_id']][$idx]['id']; ?>
                        <?php $jsMbrID = encode_id($member['user_id']); ?>
                        <?php $jsID = encode_id($member['user_id']).'_'.encode_id($a['qid']); ?>
                        <input type="hidden" name="feedback_id_<?php echo $jsID; ?>" value="<?php echo ($feedback_id)?encode_id($feedback_id):""; ?>" />

                        <?php switch ($a['answer_type']):
                            case "SCALE": ?>
                            <?php $feedback_sum[$member['user_id']] += intval($feedback);?>
                            <td>
                                <select name="<?php echo 'feedback_'.$jsID; ?>"  class="form-control form-control-sm score score-<?php echo $jsMbrID; ?>" user-name="<?php echo $jsMbrID; ?>" required>
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
                                <select name="<?php echo 'feedback_'.$jsID; ?>"  class="form-control form-control-sm grade grade-<?php echo $jsMbrID; ?>" user-name="<?php echo $jsMbrID; ?>" required>
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
                                <input type="number" min="0" max="100" step="1" value="<?php echo html_escape($feedback); ?>" name="<?php echo 'feedback_'.$jsID; ?>" class="form-control form-control-sm" required/>
                            </td>
                        <?php break; ?>
                        <?php default: ?>
                            <td>
                                <input type="text" value="<?php echo html_escape($feedback); ?>" name="<?php echo 'feedback_'.$jsID; ?>" class="form-control form-control-sm" required/>
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
                        <?php $jsMbrID = encode_id($member['user_id']); ?>
                        <td class="text-bold" id="sum_<?php echo $jsMbrID; ?>" class="sum sum-<?php echo $jsMbrID; ?>" user-name="<?php echo $jsMbrID; ?>"><?php echo  $feedback_sum[$member['user_id']]; ?></td>
                    <?php endif; ?>
                    <?php endforeach; ?>
                </tr>
            </tfoot>
        </table>
    </div>
</fieldset>
<?php echo form_close(); ?>
<?php endif; ?>