<div class="card">
  <div class="card-header bg-secondary">
    <h3 class="card-title">Peer Marking Statistic</h3>
    <div class="card-tools">
      <!-- Collapse Button -->
      <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
    </div>
    <!-- /.card-tools -->
  </div>
  <!-- /.card-header -->
  <div class="card-body">
    <div class="callout callout-success">
        <h5><b>Peer Score: </b>
            <?php echo sprintf("%.2f", ($summary[0]['override_score'] != NULL)? $summary[0]['override_score']:$summary[0]['peer_average']) ; ?>
            <?php echo ($summary[0]['override_score'] != NULL)? "<small class='text-muted'><i>Overrided</i></small>":"" ; ?>
        </h5>
    </div>
    <table class="table table-sm table-head-fixed table-hover">
        <thead>
            <tr>
                <th class="align-text-top">Student ID</th>
                <th class="align-text-top">Username</th>
                <th class="align-text-top">Student Name</th>
                <th class="align-text-top">Group</th>
                <th class="align-text-top">Group Score</th>
                <th class="align-text-top">Peer Average</th>
                <th class="align-text-top">Peer Min</th>
                <th class="align-text-top">Peer Max</th>
                <th class="align-text-top">Peer Variance</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach($summary as $a): ?>
            <tr>
                <td><a href="<?php echo site_url('Member/full_profile/'.$a['username']); ?>"><?php echo $a['sid']; ?></a></td>
                <td><?php echo $a['username']; ?></td>
                <td><?php echo $a['first_name'] . ' ' . $a['last_name'] ; ?></td>
                <?php if (empty($a['topic_id'])) : ?>
                    <td class="text-muted">*** Not assign to any groups ***</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                <?php else: ?>
                    <td><?php echo $a['topic'] ; ?></td>
                    <td><?php echo sprintf("%.2f", $a['group_score']) ; ?></td>
                    <td><?php echo sprintf("%.2f", $a['peer_average']) ; ?></td>
                    <td><?php echo sprintf("%.2f", $a['peer_min_score']) ; ?></td>
                    <td><?php echo sprintf("%.2f", $a['peer_max_score']) ; ?></td>
                    <td class="<?php echo ($a['peer_var']>=10) ? 'text-danger text-bold':'';?> "><?php echo sprintf("%.2f", $a['peer_var']) ; ?></td>
                <?php endif; ?>
            </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
    <?php if (!empty($summary[0]['group_remark'])): ?>
    <div class="callout callout-success">
        <p><b>Group Feedback:</b></p>
        <span><?php echo $summary[0]['group_remark']; ?></span>
    </div>
    <?php endif; ?>
    <?php if (!empty($summary[0]['override_score_remark'])): ?>
    <div class="callout callout-success">
        <p><b>Individual Feedback:</b></p>
        <span><?php echo $summary[0]['override_score_remark']; ?></span>
    </div>
    <?php endif; ?>
  </div>
  <!-- /.card-body -->
</div>
<!-- /.card -->

<div class="card">
  <div class="card-header bg-secondary">
    <h3 class="card-title">Peer Evaluation</h3>
    <div class="card-tools">
      <!-- Collapse Button -->
      <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
    </div>
    <!-- /.card-tools -->
  </div>
  <!-- /.card-header -->
  <div class="card-body">
    <?php foreach($assignment_topics_member as $member):  ?>
        <?php if ($member['user_id'] != $username) :?>
        <?php $feedback_sum[$member['user_id']] = 0; ?>
        <?php endif; ?>
    <?php endforeach; ?>
    <table class="table table-sm table-head-fixed table-hover">
        <thead>
            <tr>
                <th class="align-text-top">No.</th>
                <th  class="align-text-top" style="width: 50%">Question</th>
                <?php foreach($assignment_topics_member as $member) : ?>
                <?php if ($member['user_id'] != $username) :?>
                    <th class="align-text-top"><?php echo $member['first_name']; ?> <?php echo $member['last_name']; ?></th>
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
                </td>
                <td class="text-justify"><?php echo $a['question']; ?></td>
                <?php foreach($assignment_topics_member as $member):  ?>
                <?php if ($member['user_id'] != $username) :?>
                    <?php $feedback = $assignment_questions_peer[$member['user_id']][$idx]['feedback']; ?>
                    <?php $feedback_id = $assignment_questions_peer[$member['user_id']][$idx]['id']; ?>

                    <?php switch ($a['answer_type']):
                        case "SCALE": ?>
                        <?php $feedback_sum[$member['user_id']] += intval($feedback);?>
                        <td>
                            <select name="<?php echo 'feedback_'.$member['user_id'].'_'.$a['qid']; ?>"  class="form-control form-control-sm score score-<?php echo $member['user_id']; ?>" user-name="<?php echo $member['user_id']; ?>" disabled>
                            <option value="" disabled  <?php echo empty($feedback)?"selected" :""; ?>></option>
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
                            <select name="<?php echo 'feedback_'.$member['user_id'].'_'.$a['qid']; ?>"  class="form-control form-control-sm grade grade-<?php echo $member['user_id']; ?>" user-name="<?php echo $member['user_id']; ?>" disabled>
                            <option value="" disabled <?php echo empty($feedback)?"selected" :""; ?>></option>
                            <option value="HD" <?php echo ($feedback == "HD")?"selected" :""; ?>>HD</option>
                            <option value="DN" <?php echo ($feedback == "DN")?"selected" :""; ?>>DN</option>
                            <option value="CR" <?php echo ($feedback == "CR")?"selected" :""; ?>>CR</option>
                            <option value="PP" <?php echo ($feedback == "PP")?"selected" :""; ?>>PP</option>
                            <option value="NN" <?php echo ($feedback == "NN")?"selected" :""; ?>>NN</option>
                            </select>
                        </td>
                    <?php break; ?>
                    <?php case "SCORE": ?>
                        <td class='text-muted bg-light'>
                            <?php echo html_escape($feedback); ?>
                        </td>
                    <?php break; ?>
                    <?php default: ?>
                        <td class='text-muted bg-light'>
                            <?php echo html_escape($feedback); ?>
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
</div>
  <!-- /.card-body -->
</div>
<!-- /.card -->


<div class="card">
  <div class="card-header bg-secondary">
    <h3 class="card-title">Self Evaluation</h3>
    <div class="card-tools">
      <!-- Collapse Button -->
      <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
    </div>
    <!-- /.card-tools -->
  </div>
  <!-- /.card-header -->
  <div class="card-body">
    <table class="table table-sm table-head-fixed table-hover">
        <thead>
            <tr>
                <th class="align-text-top">No.</th>
                <th class="align-text-top" style="width: 50%">Question</th>
                <th class="align-text-top" style="width: 40%">Answer</th>
            </tr>
        </thead>
        <tbody>
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
        </tbody>
    </table>
</div>
  <!-- /.card-body -->
</div>
<!-- /.card -->


