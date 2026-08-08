<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'password',
        'phone',
        'role',
        'department',
        'is_active',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
        'is_active' => 'boolean',
    ];

    public function lvmdpInspections()
    {
        return $this->hasMany(LvmdpInspection::class);
    }

    public function stpInspections()
    {
        return $this->hasMany(StpInspection::class);
    }

    public function electricalLogs()
    {
        return $this->hasMany(ElectricalLog::class);
    }

    public function waterLogs()
    {
        return $this->hasMany(WaterLog::class);
    }

    public function checklists()
    {
        return $this->hasMany(Checklist::class);
    }

    public function syncQueueItems()
    {
        return $this->hasMany(SyncQueue::class);
    }

    public function isAdmin()
    {
        return $this->role === 'admin';
    }

    public function isEngineer()
    {
        return $this->role === 'engineer';
    }
}
