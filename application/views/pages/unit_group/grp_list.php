<option value="" disabled selected>*** Not Assigned to Groups ***</option>
<?php foreach($group_list as $g): ?>
    <option value="<?php echo $g['unit_group_id']; ?>" <?php echo ($g['unit_group_id'] == $selected_id)? "selected":"" ;?> <?php echo ($g['cnt'] >= $g['max'])? "disabled":"" ;?>><?php echo $g['group_desc'] . ' ('.$g['cnt'].'/'.$g['max'].')'; ?></option>
<?php endforeach; ?>
