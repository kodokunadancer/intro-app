<?php

declare(strict_types=1);

namespace App\Policies;

use App\User;
use Illuminate\Auth\Access\HandlesAuthorization;

class EditProfilePolicy
{
    use HandlesAuthorization;

    /**
     * プロフィール編集の権限があるかチェック
     *
     * @param User $user
     * @return mixed
     */
    public function view(User $user)
    {
        $profile = $user->profiles()->first();
        return $user->id == $profile->user_id;
    }
}
