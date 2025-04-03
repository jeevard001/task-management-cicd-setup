<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Task extends Model
{
    /** @use HasFactory<\Database\Factories\TaskFactory> */
    use HasFactory;

    protected $fillable = ['user_id', 'name', 'description','priority', 'status', 'completion_percentage'];

    public function users(){
        return $this->belongsToMany(User::class, 'TaskUser')
            ->using(TaskUser::class)
            ->withPivot('status');
    }
    public function user()
    {
        return $this->belongsTo(User::class); // A task belongs to a user (creator)
    }

}
