// Generated by CoffeeScript 1.8.0
(function () {
    window.ChoreographyMove = (function () {
        function ChoreographyMove() {
            this.id = 0;
            this.dancer = "CubeDancer";
            this.dance = "ScaleDance";
            this.danceMaterial = "ColorDanceMaterial";
            this.dancerParams = {};
            this.danceParams = {};
            this.danceMaterialParams = {};
        }

        ChoreographyMove.prototype.move = function () {
            return this.visualizer.receiveChoreography({
                id: this.id,
                dancer: {
                    type: this.dancer,
                    params: this.dancerParams
                },
                dance: {
                    type: this.dance,
                    params: this.danceParams
                },
                danceMaterial: {
                    type: this.danceMaterial,
                    params: this.danceMaterialParams
                }
            });
        };

        return ChoreographyMove;

    })();

}).call(this);