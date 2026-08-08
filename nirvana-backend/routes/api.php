<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\LvmdpInspectionController;
use App\Http\Controllers\Api\StpInspectionController;
use App\Http\Controllers\Api\ElectricalLogController;
use App\Http\Controllers\Api\WaterLogController;
use App\Http\Controllers\Api\ChecklistController;
use App\Http\Controllers\Api\SyncController;
use App\Http\Controllers\Api\ExportController;
use App\Http\Controllers\Api\QrLocationController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

Route::prefix('api/v1')->group(function () {
    // Public routes (Authentication)
    Route::post('/auth/login', [AuthController::class, 'login']);
    Route::post('/auth/register', [AuthController::class, 'register']);
    Route::post('/auth/forgot-password', [AuthController::class, 'forgotPassword']);
    
    // Protected routes
    Route::middleware('auth:sanctum')->group(function () {
        // Authentication
        Route::post('/auth/logout', [AuthController::class, 'logout']);
        Route::get('/user', [AuthController::class, 'user']);
        
        // LVMDP Inspections
        Route::apiResource('inspections/lvmdp', LvmdpInspectionController::class);
        Route::get('inspections/lvmdp/date-range', [LvmdpInspectionController::class, 'getByDateRange']);
        
        // STP Inspections
        Route::apiResource('inspections/stp', StpInspectionController::class);
        Route::get('inspections/stp/date-range', [StpInspectionController::class, 'getByDateRange']);
        
        // Electrical Logs
        Route::apiResource('inspections/electrical', ElectricalLogController::class);
        Route::get('inspections/electrical/date-range', [ElectricalLogController::class, 'getByDateRange']);
        
        // Water Logs
        Route::apiResource('inspections/water', WaterLogController::class);
        Route::get('inspections/water/date-range', [WaterLogController::class, 'getByDateRange']);
        
        // Checklists
        Route::apiResource('inspections/checklist', ChecklistController::class);
        Route::get('inspections/checklist/shift/{shift}', [ChecklistController::class, 'getByShift']);
        
        // Sync
        Route::post('/sync', [SyncController::class, 'syncData']);
        Route::get('/sync/status', [SyncController::class, 'getSyncStatus']);
        
        // Export
        Route::post('/export/pdf', [ExportController::class, 'exportPdf']);
        Route::post('/export/excel', [ExportController::class, 'exportExcel']);
        
        // QR Locations
        Route::apiResource('qr-locations', QrLocationController::class);
        Route::get('qr-locations/code/{code}', [QrLocationController::class, 'getByCode']);
    });
});
