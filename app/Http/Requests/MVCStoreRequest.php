<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class MVCStoreRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'mvcs' => 'required|array',
            'mvcs.*.mvc' => 'required|string',
            'mvcs.*.confidence_rating' => 'nullable|integer|between:1,100',
        ];
    }
}
