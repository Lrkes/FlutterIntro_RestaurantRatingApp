from django.shortcuts import render

from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json

@csrf_exempt
def submit_feedback(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        print("Received Feedback:", data)
        return JsonResponse({"message": "Feedback received!"})
    return JsonResponse({"error": "Only POST allowed"}, status=405)
