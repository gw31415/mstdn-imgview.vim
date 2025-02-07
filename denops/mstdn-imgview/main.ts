import type { Denops } from "jsr:@denops/std";
import { graphics } from "npm:systeminformation";

/** Get the ratio of the screen's logical pixel size to the actual pixel size. */
async function getRetinaScale(): Promise<number> {
	try {
		const graphicsData = await graphics();
		if (graphicsData.displays && graphicsData.displays.length > 0) {
			const display =
				graphicsData.displays.find((d) => d.main) || graphicsData.displays[0];

			if (display.resolutionX && display.currentResX) {
				const scaleFactor = display.resolutionX / display.currentResX;
				return scaleFactor;
			}
		}
	} finally {
		// do nothing
	}
	return 1;
}

export async function main(denops: Denops): Promise<void> {
	denops.dispatcher = {
		getRetinaScale,
	};
}
