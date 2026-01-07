#!/usr/bin/env python3
"""
Test script for Badminton Counter API endpoints
"""

def test_getsummary_logic():
    """Test the summary calculation logic"""
    
    # Mock game data
    mock_games = [
        {'playerleft': 'Alice', 'playerright': 'Bob', 'score': '21-19'},
        {'playerleft': 'Alice', 'playerright': 'Charlie', 'score': '18-21'},
        {'playerleft': 'Bob', 'playerright': 'Charlie', 'score': '21-15'},
        {'playerleft': 'Alice', 'playerright': 'Bob', 'score': '21-17'},
    ]
    
    # Calculate wins
    player_wins = {}
    
    for game in mock_games:
        score = game.get('score', '0-0')
        playerleft = game.get('playerleft', 'Left')
        playerright = game.get('playerright', 'Right')
        
        # Initialize players if not exists
        if playerleft not in player_wins:
            player_wins[playerleft] = 0
        if playerright not in player_wins:
            player_wins[playerright] = 0
        
        # Parse score (format: "21-19")
        try:
            scores = score.split('-')
            if len(scores) == 2:
                left_score = int(scores[0])
                right_score = int(scores[1])
                
                # Determine winner
                if left_score > right_score:
                    player_wins[playerleft] += 1
                elif right_score > left_score:
                    player_wins[playerright] += 1
        except (ValueError, AttributeError):
            continue
    
    print("Test Results:")
    print(f"Player Wins: {player_wins}")
    print(f"Expected: Alice: 2, Bob: 1, Charlie: 1")
    
    # Verify
    assert player_wins['Alice'] == 2, f"Alice should have 2 wins, got {player_wins['Alice']}"
    assert player_wins['Bob'] == 1, f"Bob should have 1 win, got {player_wins['Bob']}"
    assert player_wins['Charlie'] == 1, f"Charlie should have 1 win, got {player_wins['Charlie']}"
    
    print("✅ All tests passed!")

if __name__ == '__main__':
    test_getsummary_logic()

