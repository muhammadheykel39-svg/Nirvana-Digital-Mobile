<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LvmdpInspection extends Model
{
    use HasFactory;

    protected $fillable = [
        'date',
        'time_slot',
        'ampere_r',
        'ampere_s',
        'ampere_t',
        'volt_rs',
        'volt_st',
        'volt_tr',
        'cos_phi',
        'kw',
        'kwh',
        'hz',
        'user_id',
        'is_synced',
    ];

    protected $casts = [
        'date' => 'date',
        'ampere_r' => 'decimal:2',
        'ampere_s' => 'decimal:2',
        'ampere_t' => 'decimal:2',
        'volt_rs' => 'decimal:2',
        'volt_st' => 'decimal:2',
        'volt_tr' => 'decimal:2',
        'cos_phi' => 'decimal:2',
        'kw' => 'decimal:2',
        'kwh' => 'decimal:2',
        'hz' => 'decimal:2',
        'is_synced' => 'boolean',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public static function getTimeSlots()
    {
        return ['00:00', '05:00', '07:00', '09:00', '11:00', '13:00', '15:00', '17:00', '19:00', '21:00'];
    }
}
